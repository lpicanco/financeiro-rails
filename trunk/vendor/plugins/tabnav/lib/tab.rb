module Tabnav
  class Tab
    attr_reader :highlights, :link, :name, :title
    attr_accessor :page
    
    def initialize &block
      @highlights = []
      @condition = "true"
      instance_eval(&block);  
    end
    
    def page=(p)
      @page = p
      eval_dynamic_attributes
    end
    
    # setter methods
    # they're used inside the Tabnav definition
   
    def named name
      check_string_or_proc name, 'name'
      @name = name
    end  
     
    def titled title
      check_string_or_proc title, 'title'
      @title = title
    end
         
    def links_to options={}
      @link=options
      highlights_on @link  
    end
        
    def highlights_on options={}
      check_hash_or_proc options, 'highlight_on options'
      @highlights << options
    end
    
    def show_if(condition)
      @condition = condition
    end
    
    # Utility methods
    
    def visible?
      eval_dynamic_attributes
      @condition
    end
    
    # takes in input a Hash (usually params)
    def highlighted? options={}
      eval_dynamic_attributes
      result = false
      
      @highlights.each do |h| # for every highlight
        highlighted = true
        h.each_key do |key|   # for each key
          highlighted &= h[key]==options[key]   
        end 
        result |= highlighted
      end
      return result
    end
    
    # getters
    # used by the tabnav's partial
    
    # Evaluates Proc fields in the context of the page
    def eval_dynamic_attributes
      check_page
    
      #name
      @name = @page.instance_eval(&@name) if @name.kind_of? Proc
      check_string @name, 'name'

      #title
      @title = @page.instance_eval(&@title) if @title.kind_of? Proc
      check_string @title, 'title'
              
      # link
      @link = @page.instance_eval(&@link) if @link.kind_of? Proc
      check_hash @link, 'link'
      
      # highlights
      @highlights.collect! do |h|
        h.kind_of?(Proc) ?  @page.instance_eval(&h) : h
      end
      @highlights.each {|h| check_hash h, 'highlight'}
    
      # show_if
      @condition = @page.instance_eval(@condition) if @condition.kind_of?(String)
      @condition = @page.instance_eval(&@condition) if @condition.kind_of?(Proc)
    end
    
    private 
    
    def check_string_or_proc p, field
      unless p.kind_of?(String) or p.kind_of? Proc 
        raise "#{field} should be a String or a Proc"
      end  
    end
    
    def check_hash_or_proc p, field
      unless p.kind_of?(Hash) or p.kind_of? Proc 
        raise "#{field} should be a Hash or a Proc"
      end  
    end
    
    def check_string s, field
      return if s.nil?
      raise "#{field} should be a String and is a #{s.class}" unless s.kind_of?(String)  
    end
    
    def check_hash param, field
      raise "#{field} should be a Hash" if not param.kind_of? Hash
    end
    
    def check_page 
      raise "You must set a page before calling this method" unless @page
    end 
  end
end