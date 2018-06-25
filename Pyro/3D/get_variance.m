function results = get_variance(c)
results=[];
%     figure()
%     histogram(c)
[b,xi]=ksdensity(c);
[pks,loc,width,prom]=findpeaks(b,xi,'Annotate','extents','WidthReference','halfheight');
prm_srt = sort(prom);
% Find 2nd largest peak
outlier_loc = find(prom==prm_srt(size(prm_srt,2)-1));
%     if 2nd most prominent is also widest
if outlier_loc == find(width==max(width))
%         Then it is the main peak, so need to choose different outluer
    peak_loc = outlier_loc;
    outlier_loc = find(prom==max(prom));
else
    peak_loc = find(prom==max(prom));
end
min_data = loc(outlier_loc)+ width(outlier_loc);

% erase_data = find(xi<min_data);
% xi(erase_data) = [];c
% b(erase_data) = [];
erase_data = find(c<min_data);
c(erase_data)=[];

%     figure()
%     histogram(c)

% average intensity
results(1) = mean(c);
% measure of spread (inc outliers)
results(2) = mad(c);
% inter-quartile range - spread of T, resistant to outliers
results(3) = iqr(c);
% variance - spread of T, not resistant to outliers
results(4) = var(c);
