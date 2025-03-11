// ログインを勧めるタブ
function recommendLogin(){
  const funcIcons = document.querySelectorAll(".func-icon");
  const loginTab = document.querySelector(".login-tab");
  const backgroundCover = document.getElementById("background-cover");
  if (funcIcons&&loginTab) {
    funcIcons.forEach(icon => {
      icon.addEventListener("click", function(e){
        e.stopPropagation();
        loginTab.style.display = "block";
        backgroundCover.style.display = "block";
      });
    });
    document.addEventListener("click", function(e){
      loginTab.style.display = "none";
      backgroundCover.style.display = "none";
    });
    loginTab.addEventListener("click", function(e){
      e.stopPropagation();
    });
  };
};
document.addEventListener("turbo:load", function(){
  recommendLogin();
});

// トップページ　チュートリアル表示
function openTutorial(){
    const tutorialBox = document.getElementById("tutorial-box");
    const boxTitle = document.getElementById("title-text");
    const boxContent = document.getElementById("box-content");
    if(boxTitle&&boxContent) {
      boxTitle.addEventListener("click", function(e){
        boxContent.style.display="block";
        e.stopPropagation();
      });
      document.addEventListener('click', function(e) {
        boxContent.style.display="none";
        e.stopPropagation();
      });
    };
  };
document.addEventListener("turbo:load", function(){
  openTutorial();
});
