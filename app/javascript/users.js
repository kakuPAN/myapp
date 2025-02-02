

// 退会チェックボックス
document.addEventListener('turbo:load', () => {
  const checkbox1 = document.getElementById('confirmation_1');
  const checkbox2 = document.getElementById('confirmation_2');
  const deleteButton = document.getElementById('delete-button');
  if (checkbox1&&checkbox2){
    function updateButtonState() {
      if (checkbox1.checked && checkbox2.checked) {
        deleteButton.disabled = false;
      } else {
        deleteButton.disabled = true;
      }
    }

    // チェックボックスの変更を監視
    checkbox1.addEventListener('change', updateButtonState);
    checkbox2.addEventListener('change', updateButtonState);
  };
});
