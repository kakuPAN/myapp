// コメント欄
// <!-- 表示領域の高さを変更する場合には"800"も同時に変更する-->
function moveChat(){
  const commentTrack = document.querySelector(".comment-track");
  if (!commentTrack) return;
  const comments = document.querySelectorAll(".comment-text");
  const commentCount = comments.length;
  const speed = 50;
  
  let duration, endTranslate
  endTranslate = 800
  duration = endTranslate / speed
  commentTrack.style.setProperty("--end-translate", `${endTranslate}px`);
  commentTrack.style.setProperty("--animation-duration", `${duration+commentCount*0.1*commentCount}s`); //speedを一定にしてもコメントが増えるほど加速していくので、調整
  };
document.addEventListener("turbo:load", function(){
  moveChat();
});


// チャットフォーム表示
function displayForm(){
  const commentForm = document.querySelector(".comment-form-wrapper");
  const commentButton = document.getElementById("comment-button");
  const backgroundCover = document.getElementById("background-cover");
  if(commentForm&&commentButton){
    commentButton.addEventListener("click", function(e){
      e.stopPropagation();
      commentForm.style.display = "block";
      backgroundCover.style.display = "block";
    })
    document.addEventListener("click", function(e){
      commentForm.style.display = "none";
      backgroundCover.style.display = "none";
    });
    commentForm.addEventListener("click", function(e){
      e.stopPropagation();
    });
  };
}

document.addEventListener("turbo:load", function(){
  displayForm();
});

// リプライフォームの表示
function initializeReplyForm() {
  const toComments = document.querySelectorAll("[id^='to-comment-']");
  toComments.forEach(container => {
    const commentNumber = container.id.replace("to-comment-", "");
    const replyForm = document.getElementById(`reply-hundler-${commentNumber}`);
    if (container && replyForm) {
      container.addEventListener("click", function(e){
        e.stopPropagation();
        replyForm.style.display = "block";
      });
      document.addEventListener("click", function(e){
        replyForm.style.display = "none";
      });
      replyForm.addEventListener("click", function(e){
        e.stopPropagation();
      });
  }});
};
document.addEventListener("turbo:load", function () {
  initializeReplyForm();
});
document.addEventListener("click", function () {
  initializeReplyForm();
});

