# This script provides an easy way to access arbitrary windows by name.
#
# For example, if you're on window 0, and you have a pm window with "john" on window 1, 
# and a channel "#jobs" on window 2, /f jo will move to the pm window with john. If you
# press it again, it will move to #jobs, etc.
# It can also tab complete, so /f j<TAB> will complete to john and #jobs
#
# released under the WTFPL (http://www.wtfpl.net/txt/copying/)

use Irssi;

$VERSION = '1.0';
%IRSSI = (
	authors		=> 'Tom Mason',
	contact		=> 'wheybags@wheybags.com',
	name		=> 'winFind',
	description	=> 'Select windows by name',
	license		=> 'WTFPL',
);

Irssi::signal_add_first('complete word', sub 
    {
        my ($strings, $window, $word, $linestart, $want_space) = @_;

        return unless ($linestart eq '/f' && $word ne '');

        for(my $winNum = 1;; $winNum++)
        {

            my $window = Irssi::window_find_refnum($winNum);

            if(not defined $window)
            {
                    last;
            }
            
            my $title = $window->{active}->{visible_name};

            if($title =~ /^$word/i or $title =~ /^#$word/i or $title =~/^&$word/i)
            {
                if(not $title ~~@$strings)
                {
                    push(@$strings, "".$title);
                }
            }
        }
    }
);

Irssi::command_bind(
	f => sub 
    {
		my @args = split(' ', $_[0]);

        my $current = Irssi::active_win->{refnum};
        
        my $done = 0;

        for(my $winNum = $current+1;; $winNum++)
        {
            if($winNum == 0)
            {
                $winNum++;
            }

            my $window = Irssi::window_find_refnum($winNum);

            if(not defined $window)
            {
                if($done)
                {
                    last;
                }

                $done = 1;
                $winNum = 0;
            }
            
            my $title = $window->{active}->{visible_name};

            if($title =~ /^@args[0]/i or $title =~ /^#@args[0]/i or $title =~/^&@args[0]/i)
            {
                $window->set_active();
                last;
            }
        }

        #$window = Irssi::active_win;
        #$window->print($window);
        #$window->print($window->{active}->{visible_name});
        
        #$window->set_active();
    }
);

