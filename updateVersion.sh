today=`date '+%Y/%m/%d %H:%M'`;
versionid="XP1200-$today";
versionline="fmcVersion=\"$versionid\"";
echo $versionline >> plugins/xtlua/scripts/B777.30.xt.simconfig/version.lua
git add --all
