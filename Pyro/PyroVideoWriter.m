imageNames = dir('*.jpg');
imageNames = {imageNames.name}';
outputVideo = VideoWriter('shuttle_ot.avi');
outputVideo.FrameRate = 0.1;
open(outputVideo)
for ii = 1:3
   img = imread([A{ii}(1:end-4) '.jpg']);
   writeVideo(outputVideo,img)
end
close(outputVideo)
