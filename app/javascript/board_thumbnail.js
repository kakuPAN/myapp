// トピックサムネイル表示
document.addEventListener("turbo:load", function () {
  const boardContainers = document.querySelectorAll("[id^='board-content-']");
    boardContainers.forEach(container => {
      const boardNumber = container.id.replace("board-content-", "");
      const thumbnail = document.getElementById(`board-thumbnail-container-${boardNumber}`);
      const thumbnailWrapper = document.getElementById(`board-thumbnail-wrapper-${boardNumber}`);
      if (container && thumbnail) {
        container.addEventListener("mouseover", () => {
            thumbnail.style.display = "block";
          })
      }
      thumbnailWrapper.addEventListener("mouseout", () => {
          thumbnail.style.display = "none";
      });
  });
});
