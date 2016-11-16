#!/bin/bash

date;echo 'win_ie6'
BROWSER=win_ie6 bundle exec ruby web_pc.rb
date;echo 'win_ie11'
BROWSER=win_ie11 bundle exec ruby web_pc.rb
date;echo 'win_ie10'
BROWSER=win_ie10 bundle exec ruby web_pc.rb
date;echo 'win_edge'
BROWSER=win_edge bundle exec ruby web_pc.rb
date;echo 'win_ff'
BROWSER=win_ff bundle exec ruby web_pc.rb
date;echo 'win_chrome'
BROWSER=win_chrome bundle exec ruby web_pc.rb
date;echo 'mac_chrome'
BROWSER=mac_chrome bundle exec ruby web_pc.rb
date;echo 'mac_safari'
BROWSER=mac_safari bundle exec ruby web_pc.rb

date;echo 'android'
BROWSER=android bundle exec ruby web_sp.rb
date;echo 'iOS'
BROWSER=iOS bundle exec ruby web_sp.rb
