json.count @senders.count

i = 0
json.ids @ids do |id|
	json.set!(id, @senders[i].phone)
end