JsonapiSpecHelpers::Payload.register(:story) do
  key(:headline, String)
  key(:lead, String)
  key(:source, String)
  key(:permalink, String)
  timestamps!
end
