#!/usr/bin/env node

var ffmpeg = require('fluent-ffmpeg');
var fs = require('fs');
var youtubedl = require('youtube-dl');
var moment = require('moment');
var parse = require('url-parse');
var argv = require('yargs')
  .usage('Usage: $0 -url [youtube url]')
  .demand(['url'])
  .argv;

var videoFolder = './videos/';
var thumbFolder = './thumbnails/';

function getQueryVariable(url, variable) {
  var parsedUrl = parse(url);
   var vars = parsedUrl.query.replace(/^\?/, '').split('&');
   for (var i = 0; i < vars.length; i++) {
       var pair = vars[i].split('=');
       if (decodeURIComponent(pair[0]) == variable) {
           return decodeURIComponent(pair[1]);
       }
   }
   console.log('Query variable %s not found', variable);
}

var videoToThumbnails = function(videoId, duration) {
  var proc = ffmpeg(videoFolder + videoId + '.mp4')
    .on('end', function(files) {
      console.log('screenshots saved');
    })
    .on('error', function(err) {
      console.log('an error happened: ' + err.message);
    })
    .thumbnails({
      count: duration,
      filename: 'thumb_%b_%i.png'
    }, thumbFolder);
}

var downloadUrl = function(url) {
  var youtubeId = getQueryVariable(url, 'v'),
      output = videoFolder + youtubeId + '.mp4';

  var video = youtubedl(url);
  video.pipe(fs.createWriteStream(output));

  video.on('end', function() {
    console.log('finished downloading!');
    ffmpeg.ffprobe(output,function(err, metadata) {
      var duration = parseInt(metadata.format.duration);
      videoToThumbnails(youtubeId, duration);
    });
  });
}

downloadUrl(argv.url);
