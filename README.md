# meta_missing

    require "meta_missing"

    class AnimalFarm
      prepend MetaMissing
      
      handle_methods_like(/pony/) do |name, *args, &block|
        [self, name, args, block_given?, block, block[]]
      end
      
      handle_methods_like(/kitties/) do
        ["Meow meow meow", block_given?]
      end
    end
    
### And then try the following:

    > AnimalFarm.new.mecha_pony(1, 2, 3) { 4 }
    > AnimalFarm.new.kitties
    
    #=> [#<AnimalFarm:0x007fce22b69188>, :mecha_pony, [1, 2, 3], true, #<Proc:0x007fce22b69110@(pry)>, 4]
    #=> ["Meow meow meow", false]
    
### Contrast this with:
    
    > AnimalFarm.new.pigs
    
    #=> NoMethodError: undefined method `pigs' for #<Foo:0x007fd74fccab90>

## Contributing to meta_missing
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Evan Senter. See LICENSE.txt for
further details.

