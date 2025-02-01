// プルダウン
document.addEventListener('turbo:load', function() {
  const mypageContainer = document.getElementById('mypageContainer');
  const mypageDropdown = document.querySelector('.mypage-dropdown');

  if (mypageContainer) {

    mypageContainer.addEventListener('mouseover', function() {
      mypageDropdown.style.display = 'block'
      event.stopPropagation(); // キャプチャおよびバブリング段階において現在のイベントのさらなる伝播を阻止
    });

    document.addEventListener('click', function() {
      mypageDropdown.style.display = 'none';
    });
  }
});

// サブフッターメニュー
document.addEventListener("turbo:load", function(){
  const userIcon = document.getElementById("sub-footer-icon");
  const list = document.getElementById("sub-footer-list");
  const lists = document.getElementById("sub-footer-lists");
  const menu = document.getElementById("sub-footer-menu");
  if (userIcon && menu){
    userIcon.addEventListener("click", function(e){
      menu.style.display = "block";
      if (lists) {
        lists.style.display = "none";
      }
      e.stopPropagation();
    });
    document.addEventListener("click", function(){
      menu.style.display = "none";
    });
  };
  if (list && lists) {
    list.addEventListener("click", function(e){
      lists.style.display = "block";
      menu.style.display = "none";
      e.stopPropagation();
    });
    document.addEventListener("click", function(){
      lists.style.display = "none";
    });
  };
});


// プロフィールが空の場合、表示領域のボーダーを非表示にする
document.addEventListener("turbo:load", function () {
  const usersIntro = document.getElementById("users-intro");
  const userSettingLink = document.getElementById("users-setting");
  const settingContainer = userSettingLink?.parentElement;

  if (usersIntro) {
    const introText = usersIntro.textContent.trim(); ;
    if (introText.length > 0) {
      usersIntro.style.borderBottom = "2px solid #ddd";
    } else {
    usersIntro.style.borderBottom = "none";
    };
  };

  if (userSettingLink && settingContainer) {
    settingContainer.classList.add("active");
  };
});
