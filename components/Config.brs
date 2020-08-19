
' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********


'##### Feed Format from server inputting stream info #####
'## For each channel, enclose in brackets ## 
'{
'    "channelname"
'   {
'       "Title": "Channel Title"
'       "streamFormat": "Channel stream type (ex. "hls", "ism", "mp4", etc..)",
'       "Logo_sd": "Channel Logo (ex. "http://Roku.com/Roku.jpg)",
'       "Logo_hd": Channel Logo (ex. "http://Roku.com/Roku.jpg)",
'       "Logo_fhd": Channel Logo (ex. "http://Roku.com/Roku.jpg)",
'       "Stream": URL to stream (ex. http://hls.Roku.com/talks/xxx.m3u8)"
'    },
'}

'To edit the feed
'GO TO : https://jsonblob.com/380ccbf6-e238-11ea-b0bf-334f0ba01f12


Function loadConfig()
    universaltvUrl = "https://api.boxcast.com/channels/rsimwgxwmgs7awm2iv6k/broadcasts?q=timeframe%3Arelevant&s=-starts_at&l=1"
    feedUrl = "https://jsonblob.com/api/jsonBlob/380ccbf6-e238-11ea-b0bf-334f0ba01f12"
    searchRequest = CreateObject("roUrlTransfer")
    searchRequest.SetURL(feedUrl)
    searchRequest.SetCertificatesFile("common:/certs/ca-bundle.crt")
    channels = ParseJson(searchRequest.GetToString())

   if channels <> invalid 
       if channels.universaltv <> invalid then universaltvUrl = channels.universaltv.Stream
        searchRequest.SetURL(universaltvUrl)
        searchRequest.SetCertificatesFile("common:/certs/ca-bundle.crt")
        universaltvBroadcasts = ParseJson(searchRequest.GetToString())

        if universaltvBroadcasts <> invalid 
            searchRequest.SetURL(Substitute("https://api.boxcast.com/broadcasts/{0}/view", universaltvBroadcasts[0].id))
            searchRequest.SetCertificatesFile("common:/certs/ca-bundle.crt")
            universaltvPlaylist = ParseJson(searchRequest.GetToString())
            if universaltvPlaylist <> invalid 
                if channels.universaltv <> invalid then channels.universaltv.Stream = universaltvPlaylist.playlist
            end if
        end if

        arr = []

        For Each channel In channels
            arr.push(channels[channel])
        End For

        return arr
   else
    arr = [
        {
            Id: "sntv"
            Title: "SNTV"
            streamFormat: "hls"
            Logo_sd: "https://i.imgur.com/m2AoWIO.jpg"
            Logo_hd: "https://i.imgur.com/uIrqRLo.jpg"
            Logo_fhd: "https://i.imgur.com/ihaJZlT.jpg"
            Stream: "https://ap02.iqplay.tv:8082/iqb8002/s4ne/chunks.m3u8"
        }
        {
            Id: "universaltv"
            Title: "Universal TV"
            streamFormat: "hls"
            Logo_sd: "https://i.imgur.com/yKwAiZ8.png"
            Logo_hd: "https://i.imgur.com/d0ONNYh.png"
            Logo_fhd: "https://i.imgur.com/J40p2CA.png"
            Stream: universaltvUrl
        }
        {
            Id: "hctv"
            Title: "Horn Cable TV"
            streamFormat: "hls"
            Logo_sd: "https://i.imgur.com/FHLMAyx.jpg"
            Logo_hd: "https://i.imgur.com/m1WHaas.jpg"
            Logo_fhd: "https://i.imgur.com/Mvcl9KZ.jpg"
            Stream: "http://cdn.mediavisionuae.com:1935/live/hctvlive.stream/playlist.m3u8"
        }
        {
            Id: "pltv"
            Title: "Puntland TV"
            streamFormat: "hls"
            Logo_sd: "https://i.imgur.com/ptjmvUC.jpg"
            Logo_hd: "https://i.imgur.com/7Os8OWm.jpg"
            Logo_fhd: "https://i.imgur.com/Zmf8pzT.jpg"
            Stream: "https://ap02.iqplay.tv:8082/iqb8002/p2t25/chunks.m3u8"
        }
        {
            Id: "sctv"
            Title: "Somali Cable TV"
            streamFormat: "hls"
            Logo_sd: "https://i.imgur.com/5OTR1PA.jpg"
            Logo_hd: "https://i.imgur.com/Ekqpvjq.jpg"
            Logo_fhd: "https://i.imgur.com/GiDvi3s.jpg"
            Stream: "https://ap02.iqplay.tv:8082/iqb8002/somc131/chunks.m3u8"
        }
        {
            Id: "kalsantv"
            Title: "Kalsan TV"
            streamFormat: "hls"
            Logo_sd: "https://i.imgur.com/TGN18a6.jpg"
            Logo_hd: "https://i.imgur.com/8PlD1rV.jpg"
            Logo_fhd: "https://i.imgur.com/JN0duno.jpg"
            Stream: "http://cdn.mediavisionuae.com:1935/live/kalsantv.stream/playlist.m3u8"
        }

        {
            Id: "bulshotv"
            Title: "Bulsho TV"
            streamFormat: "hls"
            Logo_sd: "https://i.imgur.com/eT0IJeM.jpg"
            Logo_hd: "https://i.imgur.com/qV9t5qJ.jpg"
            Logo_fhd: "https://i.imgur.com/9jg8J2a.jpg"
            Stream: "https://ap02.iqplay.tv:8082/iqb8002/bu1sho41/chunks.m3u8"
        }

        {
            Id: "saabtv"
            Title: "Saab TV"
            streamFormat: "hls"
            Logo_sd: "https://i.imgur.com/jY5JO7t.jpg"
            Logo_hd: "https://i.imgur.com/K4uUrXd.jpg"
            Logo_fhd: "https://i.imgur.com/VDNckEY.jpg"
            Stream: "https://ap02.iqplay.tv:8082/iqb8002/s03btv/chunks.m3u8"
        }    
    ] 
    return arr
end if
End Function
