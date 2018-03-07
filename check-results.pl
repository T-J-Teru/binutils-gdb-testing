#!/usr/bin/perl

use warnings;
use strict;
no indirect;
no autovivification;

#========================================================================#

=pod

=head1 NAME

check-results - compare results between a baseline build, and a
                feature build.

=head1 OPTIONS

B<check-results> [-h|--help] BASE-DIR FEATURE-DIR

=head1 SYNOPSIS

The I<BASE-DIR> and I<FEATURE-DIR> are the build directories in which
the testing was run.  These directories should contain at least some
of the following file (depending on which tests were run):
configure.sum, build.sum, check-gas.sum, check-binutils.sum,
check-ld.sum.

These summary files are analysed, and results written to stdout.

The exit value will be 0 if everything passed the comparison,
otherwise, 1.

=cut

#========================================================================#

use lib "$ENV{HOME}/lib";
use GiveHelp qw/usage/;         # Allow -h or --help command line options.
use Cwd qw/abs_path/;
use boolean;
use List::MoreUtils qw/uniq/;

#========================================================================#

exit (main (@ARGV));

#========================================================================#

=pod

=head1 METHODS

The following methods are defined in this script.

=over 4

=cut

#========================================================================#

=pod

=item B<is_ignorable_count>

Currently undocumented.

=cut

sub is_ignorable_count {
  my $count_type = shift;

  return ($count_type eq 'PASS'
            or $count_type eq 'UNSUPPORTED'
            or $count_type eq 'UNTESTED'
            or $count_type eq 'XFAIL');
}

#========================================================================#

=pod

=item B<load_pass_fail_sum_file>

Currently undocumented.

=cut

sub load_pass_fail_sum_file {
  my $filename = shift;

  open my $fh, $filename or die "Couldn't open '$filename': $!\n";

  my $results = {};
  while (<$fh>)
  {
    my ($target, $status) = (m/^([^:]+):\s+(.*)$/);
    (not (exists ($results->{$target}))) or
      die "Target '$target' is repeated in '$filename'\n";
    $results->{$target} = $status;
  }

  close $fh or die "Couldn't close '$filename': $!\n";

  return $results;
}

#========================================================================#

=pod

=item B<load_counted_sum_file>

Currently undocumented.

=cut

sub load_counted_sum_file {
  my $filename = shift;

  open my $fh, $filename or die "Couldn't open '$filename': $!\n";

  my $results = {};
  while (<$fh>)
  {
    my ($target, $status, $counts) = (m/^([^:]+):\s+([^:]+):\s+(.*)$/);
    (not (exists ($results->{$target}))) or
      die "Target '$target' is repeated in '$filename'\n";
    $results->{$target} = { status => $status,
                            counts => {} };
    foreach my $c (split /\s+/, $counts)
    {
      my ($n, $v) = ($c =~ m/^([^=]+)=(\d+)/);
      (not (exists ($results->{$target}->{counts}->{$n}))) or
        die "For target '$target', field '$n' is duplicated\n";
      $results->{$target}->{counts}->{$n} = $v;
    }
  }

  close $fh or die "Couldn't close '$filename': $!\n";

  return $results;
}

#========================================================================#

=pod

=item B<check_pass_fail_sum_file>

Currently undocumented.

=cut

sub check_pass_fail_sum_file {
  my $base_dir = shift;
  my $feature_dir = shift;
  my $sum_file = shift;

  my $failed = false;
  eval
  {
    my $base_file = $base_dir."/".$sum_file;
    my $feature_file = $feature_dir."/".$sum_file;

    my $base = load_pass_fail_sum_file ($base_file);
    my $feature = load_pass_fail_sum_file ($feature_file);

    # Yuck! Need '+' in line below so sort can understand its arguments.
    foreach my $t (sort +(uniq (keys (%{$base}), keys (%{$feature}))))
    {
      if (not (exists ($base->{$t})))
      {
        print "  $t: missing in '$base_file'\n";
        $failed = true;
      }
      elsif (not (exists ($feature->{$t})))
      {
        print "  $t: missing in '$feature_file'\n";
        $failed = true;
      }
      elsif ($base->{$t} ne $feature->{$t})
      {
        print "  $t: ".$base->{$t}." -> ".$feature->{$t}."\n";
        $failed = true;
      }
    }
  };

  if ($@)
  {
    print "  FAIL: $@\n";
    return false;
  }

  if ($failed)
  {
    print "  FAIL: Differences found\n";
    return false;
  }

  print "  PASS\n";
  return true;
}

#========================================================================#

=pod

=item B<check_counted_sum_file>

Currently undocumented.

=cut

sub check_counted_sum_file {
  my $base_dir = shift;
  my $feature_dir = shift;
  my $sum_file = shift;

  my $failed = false;
  eval
  {
    my $base_file = $base_dir."/".$sum_file;
    my $feature_file = $feature_dir."/".$sum_file;

    my $base = load_counted_sum_file ($base_file);
    my $feature = load_counted_sum_file ($feature_file);

    # Yuck! Need '+' in line below so sort can understand its arguments.
    foreach my $t (sort +(uniq (keys (%{$base}), keys (%{$feature}))))
    {
      if (not (exists ($base->{$t})))
      {
        print "  $t: missing in '$base_file'\n";
        $failed = true;
      }
      elsif (not (exists ($feature->{$t})))
      {
        print "  $t: missing in '$feature_file'\n";
        $failed = true;
      }
      else
      {
        if ($base->{$t}->{status} ne $feature->{$t}->{status})
        {
          print "  $t: status change: ".$base->{$t}->{status}." -> ".
            $feature->{$t}->{status}."\n";
          $failed = true;
        }
        else
        {
          foreach my $c (sort +(uniq (keys (%{$base->{$t}->{counts}}),
                                      keys (%{$feature->{$t}->{counts}}))))
          {
            if (not (exists ($base->{$t}->{counts}->{$c})))
            {
              print "  $t: missing count '$c' in '$base_file'\n";
              $failed = true;
            }
            elsif (not (exists ($feature->{$t}->{counts}->{$c})))
            {
              print "  $t: missing in '$feature_file'\n";
              $failed = true;
            }
            elsif ($base->{$t}->{counts}->{$c} != $feature->{$t}->{counts}->{$c})
            {
              if (not (is_ignorable_count ($c)))
              {
                print "  $t: $c: ".$base->{$t}->{counts}->{$c}.
                  " -> ".$feature->{$t}->{counts}->{$c}."\n";
                $failed = true;
              }
            }
          }
        }
      }
    }
  };

  if ($@)
  {
    print "  FAIL: $@\n";
    return false;
  }

  if ($failed)
  {
    print "  FAIL: Differences found\n";
    return false;
  }

  print "  PASS\n";
  return true;
}

#========================================================================#

=pod

=item B<main>

Currently undocumented.

=cut

sub main {
  my $base_dir = shift;
  my $feature_dir = shift;

  $base_dir = abs_path ($base_dir);
  $feature_dir = abs_path ($feature_dir);

  print "Comparing:\n";
  print "    Base: $base_dir\n";
  print " Feature: $feature_dir\n";
  print "\n";

  my $passed = true;

  foreach my $sum_file (qw/configure.sum build.sum/)
  {
    print "Checking $sum_file:\n";
    $passed = check_pass_fail_sum_file ($base_dir, $feature_dir, $sum_file) && $passed;
  }

  foreach my $sum_file (qw/check-gas.sum check-binutils.sum check-ld.sum/)
  {
    print "Checking $sum_file:\n";
    $passed = check_counted_sum_file ($base_dir, $feature_dir, $sum_file) && $passed;
  }

  return ($passed ? 0 : 1);
}

#========================================================================#

=pod

=back

=head1 AUTHOR

, 04 Jan 2018

=cut
