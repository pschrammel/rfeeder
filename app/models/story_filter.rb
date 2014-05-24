class StoryFilter

  def initialize(filters={})
    filters ||= {}
    @read_later = filters[:read_later] == true || filters[:read_later] == "1"
    @unread = filters[:unread] == true || filters[:unread] == "1"
  end

  attr_reader :read_later, :unread
  alias read_later? read_later
  alias unread? unread

  def to_hash
    {:unread => @unread ? "1" : "0", :read_later => @read_later ? "1" : "0"}
  end
end