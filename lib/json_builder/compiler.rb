require 'blankslate' unless defined? BlankSlate
require 'json_builder/member'

module JSONBuilder
  class Compiler < BlankSlate
    class << self
      def generate(*args, &block)
        compiler = self.new
        compiler.compile(*args, &block)
        compiler.to_s
      end
    end
    
    attr_accessor :members
    attr_accessor :array
    
    def initialize
      @members = []
    end
    
    def compile(*args, &block)
      instance_exec(*args, &block)
    end
    
    def array(items, &block)
      @array = Elements.new(items, &block)
    end
    
    # Need to return a Key instance to allow for arrays to be handled appropriately
    def method_missing(key, *args, &block)
      member = Member.new(key, *args, &block)
      @members << member
      member
    end
    alias_method :key, :method_missing
    
    # Once all nodes are compiled, build the string
    def to_s
      @array ? @array.to_s : "{#{@members.collect(&:to_s).join(', ')}}"
    end
  end
end
