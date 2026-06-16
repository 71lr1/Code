const a=require("axios")
const fs=require("fs")
const path=require("path")
const readline=require("readline")

const envPath=path.join(__dirname,".env")
let SESSION_ID="",CSRF="",MS_TOKEN="",TTWID=""
if(fs.existsSync(envPath)){
fs.readFileSync(envPath,"utf8").split("\n").forEach(l=>{
const[k,...rest]=l.split("=")
const v=rest.join("=")
if(!k||!v)return
if(k.trim()==="SESSIONID")SESSION_ID=v.trim()
if(k.trim()==="CSRF")CSRF=v.trim()
if(k.trim()==="MSTOKEN")MS_TOKEN=v.trim()
if(k.trim()==="TTWID")TTWID=v.trim()
})
}

const logo=[
"                  _____  _____                ",
"                  \\\\\/ ___/___________________   ",
"                   \\/ /                 _____/",
"________________    \\/ /              _____/.'.'.'.'.'.'.'.'.'.'.'.'_'_'_/",
"\\_____        \\__    / /           _____/.'.'.'.'.'.'.'.'.'.'.'.'.'_'_/",
"    \\__________\\__  / /        _____/_'_'_'_'_'_'_'_'_'_'_'_'_'_'_/",
"                \\_ / /__________/",
"                 \\/____/\\\\\\",
"                      \\\\\\",
"                       ------",
]

const ITEMS=["Profile Lookup","Exit"]
let sel=0

function cls(){process.stdout.write("\x1Bc")}

function cookieHeader(){
let c=""
if(SESSION_ID)c+=`sessionid=${SESSION_ID};`
if(CSRF)c+=`tt_csrf_token=${CSRF};`
if(MS_TOKEN)c+=`msToken=${MS_TOKEN};`
if(TTWID)c+=`ttwid=${TTWID};`
return c
}

function headers(extra={}){
return{
"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
"Accept-Language":"en-US,en;q=0.9",
"Referer":"https://www.tiktok.com/",
"Cookie":cookieHeader(),
...extra
}
}

async function getPublic(u){
const{data:d}=await a.get(`https://www.tiktok.com/@${u}`,{headers:headers()})
const m=d.match(/"webapp\.user-detail":\{"userInfo":\{"user":(.*?),"stats"/s)
const s=d.match(/"stats":(.*?),"statsV2"/s)
if(!m||!s)throw new Error("user not found")
const u2=JSON.parse(m[1]),st=JSON.parse(s[1])
const created=u2.createTime?new Date(u2.createTime*1000).toISOString().split("T")[0]:"unknown"
const nameChanged=u2.nickNameModifyTime?new Date(u2.nickNameModifyTime*1000).toISOString().split("T")[0]:"never"
const unameChanged=u2.uniqueIdModifyTime&&u2.uniqueIdModifyTime>0?new Date(u2.uniqueIdModifyTime*1000).toISOString().split("T")[0]:"never"
const vMatch=d.match(/"itemList":\[(.*?)\],"hasMore"/s)
let videos=[]
if(vMatch){
try{
const raw=JSON.parse("["+vMatch[1]+"]")
videos=raw.map(v=>({
id:v.id,desc:v.desc||"(no caption)",
created:v.createTime?new Date(v.createTime*1000).toISOString().split("T")[0]:"?",
plays:v.stats?.playCount||0,likes:v.stats?.diggCount||0,
comments:v.stats?.commentCount||0,shares:v.stats?.shareCount||0,
duration:v.video?.duration||0,ratio:v.video?.ratio||"",
music:v.music?.title||"",musicAuthor:v.music?.authorName||"",
url:`https://www.tiktok.com/@${u}/${v.id}`
}))
}catch(e){}
}
return{
username:u2.uniqueId,name:u2.nickname,bio:u2.signature||"",
id:u2.id,secUid:u2.secUid,verified:u2.verified,priv:u2.privateAccount,
lang:u2.language,created,nameChanged,unameChanged,
isLive:u2.roomId&&u2.roomId.length>0,
ttSeller:u2.ttSeller,isOrg:u2.isOrganization===1,
embedBanned:u2.isEmbedBanned,
commentSetting:u2.commentSetting===0?"everyone":u2.commentSetting===1?"friends":"off",
duetSetting:u2.duetSetting===0?"everyone":u2.duetSetting===1?"friends":"off",
stitchSetting:u2.stitchSetting===0?"everyone":u2.stitchSetting===1?"friends":"off",
downloadSetting:u2.downloadSetting===0?"allowed":"restricted",
openFavorite:u2.openFavorite,followers:st.followerCount,
following:st.followingCount,likes:st.heartCount,
videoCount:st.videoCount,friends:st.friendCount,
avatar:u2.avatarThumb,profileUrl:`https://www.tiktok.com/@${u2.uniqueId}`,
videos
}
}

async function getPrivate(secUid){
const out={}
try{
const{data}=await a.get(`https://www.tiktok.com/api/user/detail/?secUid=${secUid}`,{headers:headers()})
const u=data?.userInfo?.user
if(u){out.email=u.email||"";out.phone=u.mobile||"";out.birthday=u.birthday||"";out.region=u.region||""}
}catch(e){}
try{
const{data}=await a.get(`https://www.tiktok.com/api/recommend/user/list/?count=10`,{headers:headers()})
out.suggested=(data?.userList||[]).map(x=>({username:x.user?.uniqueId,name:x.user?.nickname,followers:x.stats?.followerCount}))
}catch(e){out.suggested=[]}
try{
const{data}=await a.get(`https://www.tiktok.com/api/favorite/item_list/?secUid=${secUid}&count=10&cursor=0`,{headers:headers()})
out.liked=(data?.itemList||[]).map(v=>({id:v.id,desc:v.desc||"",plays:v.stats?.playCount||0,url:`https://www.tiktok.com/@${v.author?.uniqueId}/${v.id}`}))
}catch(e){out.liked=[]}
try{
const{data}=await a.get(`https://www.tiktok.com/api/following/list/?secUid=${secUid}&count=20&minCursor=0&maxCursor=0`,{headers:headers()})
out.following=(data?.userList||[]).map(x=>({username:x.user?.uniqueId,name:x.user?.nickname,followers:x.stats?.followerCount}))
}catch(e){out.following=[]}
try{
const{data}=await a.get(`https://www.tiktok.com/api/follower/list/?secUid=${secUid}&count=20&minCursor=0&maxCursor=0`,{headers:headers()})
out.followers=(data?.userList||[]).map(x=>({username:x.user?.uniqueId,name:x.user?.nickname,followers:x.stats?.followerCount}))
}catch(e){out.followers=[]}
return out
}

function printList(ln,sep,label,items,fields){
if(!items||items.length===0)return
console.log(sep)
console.log(ln+` \x1b[37m${label} (${items.length})\x1b[0m`)
console.log(sep)
items.forEach((item,i)=>{
fields.forEach(f=>{
if(item[f]!==undefined&&item[f]!=="")
console.log(ln+` ${f.padEnd(10)} \x1b[90m:\x1b[0m ${item[f]}`)
})
if(i<items.length-1)console.log(ln+" \x1b[90m-\x1b[0m")
})
}

async function lookup(u){
const hasCookies=SESSION_ID.length>0
cls()
logo.forEach(l=>process.stdout.write("\x1b[90m"+l+"\x1b[0m\n"))
console.log("\n\x1b[37m  searching @"+u+"\x1b[0m\n")
try{
const p=await getPublic(u)
const priv=hasCookies?await getPrivate(p.secUid):null
const ln="\x1b[90m  │\x1b[0m"
const sep="\x1b[90m  ├─────────────────────────────────┤\x1b[0m"
console.log("\x1b[90m  ┌─────────────────────────────────┐\x1b[0m")
console.log(ln+" \x1b[1m\x1b[37m@"+p.username+"\x1b[0m"+(p.verified?" \x1b[33m[verified]\x1b[0m":"")+(p.priv?" \x1b[31m[private]\x1b[0m":"")+(p.isLive?" \x1b[31m[LIVE]\x1b[0m":"")+(hasCookies?" \x1b[32m[logged in]\x1b[0m":""))
console.log(sep)
console.log(ln+" name          \x1b[90m:\x1b[0m "+p.name)
console.log(ln+" bio           \x1b[90m:\x1b[0m "+(p.bio||"\x1b[90m(empty)\x1b[0m"))
console.log(ln+" id            \x1b[90m:\x1b[0m \x1b[90m"+p.id+"\x1b[0m")
console.log(ln+" lang          \x1b[90m:\x1b[0m "+p.lang)
if(priv){
if(priv.email)console.log(ln+" email         \x1b[90m:\x1b[0m "+priv.email)
if(priv.phone)console.log(ln+" phone         \x1b[90m:\x1b[0m "+priv.phone)
if(priv.birthday)console.log(ln+" birthday      \x1b[90m:\x1b[0m "+priv.birthday)
if(priv.region)console.log(ln+" region        \x1b[90m:\x1b[0m "+priv.region)
}
console.log(sep)
console.log(ln+" created       \x1b[90m:\x1b[0m "+p.created)
console.log(ln+" name changed  \x1b[90m:\x1b[0m "+p.nameChanged)
console.log(ln+" uname changed \x1b[90m:\x1b[0m "+p.unameChanged)
console.log(sep)
console.log(ln+" followers     \x1b[90m:\x1b[0m \x1b[37m"+p.followers+"\x1b[0m")
console.log(ln+" following     \x1b[90m:\x1b[0m "+p.following)
console.log(ln+" friends       \x1b[90m:\x1b[0m "+p.friends)
console.log(ln+" likes         \x1b[90m:\x1b[0m "+p.likes)
console.log(ln+" videos        \x1b[90m:\x1b[0m "+p.videoCount)
console.log(sep)
console.log(ln+" comments      \x1b[90m:\x1b[0m "+p.commentSetting)
console.log(ln+" duet          \x1b[90m:\x1b[0m "+p.duetSetting)
console.log(ln+" stitch        \x1b[90m:\x1b[0m "+p.stitchSetting)
console.log(ln+" downloads     \x1b[90m:\x1b[0m "+p.downloadSetting)
console.log(ln+" fav public    \x1b[90m:\x1b[0m "+p.openFavorite)
console.log(ln+" embed banned  \x1b[90m:\x1b[0m "+p.embedBanned)
console.log(ln+" seller        \x1b[90m:\x1b[0m "+p.ttSeller)
console.log(ln+" organization  \x1b[90m:\x1b[0m "+p.isOrg)
console.log(sep)
console.log(ln+" avatar        \x1b[90m:\x1b[0m \x1b[90m"+p.avatar+"\x1b[0m")
console.log(ln+" profile       \x1b[90m:\x1b[0m "+p.profileUrl)
if(p.videos.length>0){
console.log(sep)
console.log(ln+" \x1b[37mvideos ("+p.videos.length+")\x1b[0m")
console.log(sep)
p.videos.forEach((v,i)=>{
console.log(ln+" \x1b[37m#"+(i+1)+" "+v.created+"\x1b[0m")
console.log(ln+" caption  \x1b[90m:\x1b[0m "+v.desc.slice(0,55)+(v.desc.length>55?"...":""))
console.log(ln+" plays    \x1b[90m:\x1b[0m "+v.plays+"  likes: "+v.likes+"  comments: "+v.comments+"  shares: "+v.shares)
console.log(ln+" duration \x1b[90m:\x1b[0m "+v.duration+"s  ratio: "+v.ratio)
console.log(ln+" music    \x1b[90m:\x1b[0m "+v.music+" - "+v.musicAuthor)
console.log(ln+" url      \x1b[90m:\x1b[0m \x1b[90m"+v.url+"\x1b[0m")
if(i<p.videos.length-1)console.log(sep)
})
}
if(priv){
printList(ln,sep,"following",priv.following,["username","name","followers"])
printList(ln,sep,"followers",priv.followers,["username","name","followers"])
printList(ln,sep,"liked videos",priv.liked,["desc","plays","url"])
printList(ln,sep,"suggested for you",priv.suggested,["username","name","followers"])
}
console.log("\x1b[90m  └─────────────────────────────────┘\x1b[0m\n")
}catch(e){console.log("\x1b[31m  error: "+e.message+"\x1b[0m\n")}
}

function renderMenu(){
cls()
logo.forEach(l=>process.stdout.write("\x1b[90m"+l+"\x1b[0m\n"))
console.log("")
ITEMS.forEach((item,i)=>{
if(i===sel)console.log("  \x1b[37m❯ "+item+"\x1b[0m")
else console.log("  \x1b[90m  "+item+"\x1b[0m")
})
console.log("")
console.log("\x1b[90m  ↑↓ navigate  enter select\x1b[0m")
}

async function promptUsername(){
cls()
logo.forEach(l=>process.stdout.write("\x1b[90m"+l+"\x1b[0m\n"))
console.log("")
return new Promise(res=>{
const rl=readline.createInterface({input:process.stdin,output:process.stdout})
rl.question("  \x1b[37m@\x1b[0m ","ans"=>{rl.close();res(ans.trim())})
})
}

async function handleSelect(){
if(sel===0){
const u=await promptUsername()
if(u)await lookup(u)
process.stdout.write("\n\x1b[90m  press enter to go back...\x1b[0m")
await new Promise(res=>{
const rl=readline.createInterface({input:process.stdin})
rl.on("line",()=>{rl.close();res()})
})
start()
}else{
cls();process.exit(0)
}
}

function start(){
renderMenu()
process.stdin.setRawMode(true)
process.stdin.resume()
process.stdin.setEncoding("utf8")
process.stdin.removeAllListeners("data")
process.stdin.on("data",key=>{
if(key==="\x1B[A"){sel=(sel-1+ITEMS.length)%ITEMS.length;renderMenu()}
else if(key==="\x1B[B"){sel=(sel+1)%ITEMS.length;renderMenu()}
else if(key==="\r"||key==="\n"){
process.stdin.setRawMode(false)
process.stdin.pause()
process.stdin.removeAllListeners("data")
handleSelect()
}else if(key==="\x03"){cls();process.exit(0)}
})
}

start()