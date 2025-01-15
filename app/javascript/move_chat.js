// コメント欄
// <!-- 表示領域の高さを変更する場合には"500"も同時に変更すること!-->
function moveChat(){
  const commentTrack = document.querySelector(".comment-track");
  if (!commentTrack) return;
  const comments = document.querySelectorAll(".comment-text");
  const commentCount = comments.length;
  const speed = 50;
  
  let duration, endTranslate
  endTranslate = 600
  duration = endTranslate / speed
  commentTrack.style.setProperty("--end-translate", `${endTranslate}px`);
  commentTrack.style.setProperty("--animation-duration", `${duration+commentCount*0.1*commentCount}s`); //speedを一定にしてもコメントが増えるほど加速していくので、調整
  };
document.addEventListener("turbo:load", function(){
  moveChat();
});
