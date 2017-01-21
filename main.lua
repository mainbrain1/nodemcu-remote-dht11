wifi.setmode(wifi.STATION)
    wifi.sta.config("siska","pass")
wifi.sta.setip({ip="192.168.0.161", netmask="255.255.255.0", gateway="192.168.0.1"})

local ws = websocket.createClient()
ws:on("connection", function(ws)
  print('got ws connection')
 local message='{"type":"auth","login":"dht11","password":"dht155","regtype":"password"}'
  ws:send(message)
end)
ws:on("receive", function(_, msg, opcode)
  print('got message:', msg, opcode) -- opcode is 1 for text message, 2 for binary
end)



ws:on("close", function(_, status)
  print('connection closed', status)
  ws = nil -- required to lua gc the websocket client
end)

ws:connect('ws://you-host.com:8888')




function term()
pin =2
status, temp, humi, temp_dec, humi_dec = dht.read11(pin)
if status == dht.OK then
    -- Integer firmware using this example
    print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
          math.floor(temp),
          temp_dec,
          math.floor(humi),
          humi_dec
    ))

    -- Float firmware using this example
    print("DHT Temperature:"..temp..";".."Humidity:"..humi)


local message=string.format('{"type":"dht","t":"%s","h":"%s"}',temp,humi)

  ws:send(message)
elseif status == dht.ERROR_CHECKSUM then
    print( "DHT Checksum error." )
elseif status == dht.ERROR_TIMEOUT then
    print( "DHT timed out." )
end
end


tmr.alarm(0,5000,1,term)