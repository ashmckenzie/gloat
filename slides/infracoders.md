!SLIDE

# Operations at Hooroo #



<br/>
### Ash McKenzie, Developer###
#### November 13 2012 ####


!SLIDE bullets smbullets



# Me #

* [@ashmckenzie](http://twitter.com/ashmckenzie)
* [http://ashmckenzie.org](http://ashmckenzie.org)


!SLIDE bullets

* Hooroo
* Development & Deployment
* Chef build pipeline
* Zero downtime
* Asynchronous Airbrake
* Infrastructure Testing


!SLIDE

# Hooroo #

[urbandictionary.com/define.php?term=hooroo](http://urbandictionary.com/define.php?term=hooroo)

<cite>An Aussie way of saying "goodbye"</cite>

!SLIDE bullets smbullets

# The company #

* Wholly owned subsidiary of the Qantas Group
* Australian focused travel site, for travellers
* Provides accomodation booking and inspirational content
* Emphasis on strong visuals and ease of use

![Hooroo](hooroo.png)


!SLIDE bullets smbullets

# The tech #

* EngineYard (AWS)
* Ruby 1.9.3, Rails 3.2.x
* nginx, Unicorn, HAProxy
* PostgreSQL 9.x, Redis

![engine_yard](engine_yard.png)
![ruby](ruby.png)
![rails](rails.png)
![nginx](nginx.png)
![unicorn](/images/unicorn.png)
![postgres](postgres.png)
![redis](redis.png)


!SLIDE bullets smbullets



# Development goodies #

* JavaScript heavy app
* Backbone brings order to the chaos
* CoffeeScript for developer productivity (and enjoyment!)
* pry allows you to 'freeze' execution and interact
* Zeus - significantly speeds up development & testing

![backbone](backbone.png)
![pry](pry.png)
![coffeescript](coffeescript.png)


!SLIDE bullets



# Deployment #

* Jenkins and Build Pipeline plugin
* Commits to master kick off build and are tested thoroughly
* Successful Staging deploy == Production deploy candidate
* Daily Production deploy, usually arround 10AM
* Takes approximately eight minutes


!SLIDE bullets smbullets



# Deployment cont'd #

* Utilise feature toggling of functionality to reduce delays
* Everyone (inc. non techs) deploy to Production
* Deployment is a single click affair in Jenkins

![deploy](deploy.png)


!SLIDE bullets



# Chef build pipeline #

* Chef recipes live within main codebase
* Chef changes detected and procesed by Jenkins
* Aim to mirror code deployment process
* Reduces environment inconsistencies


!SLIDE bullets



# Zero Downtime #

* Customers experience no service loss during deployment
* Unicorn reload (USR2) and careful DB migrations
* Great [RailsCast](http://railscasts.com/episodes/373-zero-downtime-deployment) recently covered all the gotchas

![maintenance](maintenance.png)


!SLIDE bullets smbullets



# Asynchronous Airbrake #

![airbrake](airbrake.png)

* Airbrake is great, but can be slow (submitting & their UI)
* New Relic RPM revealed delays in submitting (up to 3 secs)
* When using Ruby 1.9, async mode with [girl_friday](https://github.com/mperham/girl_friday)
* Updated to use async Airbrake submission via Resque
* Fallback to synchronous method if Resque job fails


!SLIDE language="haml"

%h1 Asynchronous Airbrake

%h2 config/initialisers/airbrake.rb

%pre
  %code{ 'data-language' => 'ruby' }
    = preserve do
      :escaped
        Airbrake.configure do |config|
          config.api_key = 12345678

          config.async do |notice|
            begin
              Resque.enqueue(AirbrakeDeliveryWorker, notice.to_xml)
            rescue
              # job submission failed, so go the slower route.
              Airbrake.sender.send_to_airbrake(notice)
            end
          end
        end

!SLIDE bullets smbullets


# Infrastructure Testing #

## Using RSpec ##


!SLIDE bullets smbullets



# Infrastructure Testing #

* Use RSpec to test infrastructure
* Common language to all developers
* Lowers barrier to add and update checks
* Integrate with Jenkins
* Drop JSON file containing state
* Open Source once complete


!SLIDE bullets smbullets

# Infrastructure Testing #

## Service definition ##

    @@@ ruby
    # nginx
    #
    shared_examples "an nginx setup" do
      it { host.should have_remote_file '/etc/nginx/nginx.conf' }
      it { host.should listen_on_local_port 81 }
    end

    # postgres
    #
    shared_examples "a postgresql setup" do
      it { host.should have_remote_file '/var/run/postgres.pid' }
      it { host.should listen_on_local_port 5432 }
    end


!SLIDE bullets smbullets

# Infrastructure Testing #

## Environment definition ##

    @@@ ruby
    shared_context "Environment" do
      describe do
        [ :app_master, :app_slaves ].each do |role|
          describe role do
            Nagios::HostManager.hostnames(environment, role).each do |hostname|
              describe hostname do
                it_behaves_like "an nginx setup"
                it_behaves_like "a haproxy setup"
              end
            end
          end
        end
      end
    end


!SLIDE bullets smbullets

# Infrastructure Testing #

## Specific environment definition ##

    @@@ ruby
    describe 'Shrubbery', :environment => :shrubbery do
      include_context "Environment"
    end

    describe 'Staging', :environment => :staging do
      include_context "Environment"
    end

!SLIDE bullets smbullets

# Demo #


!SLIDE bullets smbullets

# Thank-you! #

## Questions? ##

<br/>
We're hiring too :)

