class Tag < ActiveRecord::Base
  has_many :taggings

  def self.parse(list)
    tag_names = []

    # first, pull out the quoted tags
    list.gsub!(/\"(.*?)\"\s*/ ) { tag_names << $1; "" }

    # then, replace all commas with a space
    list.gsub!(/,/, " ")

    # then, get whatever's left
    tag_names.concat list.split(/\s/)

    # strip whitespace from the names
    tag_names = tag_names.map { |t| t.strip }

    # delete any blank tag names
    tag_names = tag_names.delete_if { |t| t.empty? }
    
    return tag_names
  end

  def tagged
    @tagged ||= taggings.collect { |tagging| tagging.taggable }
  end
  
  def on(taggable, user)
    unless user.nil?
      taggings.create :taggable => taggable, :user => user
    else
      taggings.create :taggable => taggable, :user => User.anonymous_user
    end
  end
  
  def ==(comparison_object)
    super || name == comparison_object.to_s
  end
  
  def to_s
    name
  end
  
  # My customizations
  def self.tags(options = {})
    if options[:user] != nil
      id = options[:user].id.to_s
    else
      id = User.anonymous_user.id.to_s
    end
    
    query = "select tags.id, name, count(*) as count"
    query << " from taggings, tags"
    query << " where tags.id = tag_id"
    query << " and taggings.user_id = " << id
    query << " and taggings.taggable_type = '#{options[:taggable_type]}'" if options[:taggable_type] != nil
    query << " group by tag_id"
    query << " order by #{options[:order]}" if options[:order] != nil
    query << " limit #{options[:limit]}" if options[:limit] != nil
    tags = Tag.find_by_sql(query)
  end   
  
end