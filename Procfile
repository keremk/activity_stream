web: bundle exec thin start -p $PORT -e $RACK_ENV
resque: env VVERBOSE=1 TERM_CHILD=1 RESQUE_TERM_TIMEOUT=10 bundle exec rake resque:work