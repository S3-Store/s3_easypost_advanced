document.addEventListener('DOMContentLoaded', function() {
  const paymentMethodRadios = document.querySelectorAll('input[name="order[customer_metadata][payment_method]"]');
  const accountHolderField = document.getElementById('order_customer_metadata_account_holder');
  const paymentAccountField = document.getElementById('order_customer_metadata_payment_account');
  const accountHolderLabel = document.querySelector('label[for="order_customer_metadata_account_holder"]');
  const paymentAccountLabel = document.querySelector('label[for="order_customer_metadata_payment_account"]');

  function togglePaymentFields() {
      const selectedMethod = document.querySelector('input[name="order[customer_metadata][payment_method]"]:checked');
      if (selectedMethod) {
          const selectedMethodValue = selectedMethod.value;
          if (accountHolderField && paymentAccountField && accountHolderLabel && paymentAccountLabel) {
              if (selectedMethodValue === 'Not Now') {
                  accountHolderField.style.display = 'none';
                  paymentAccountField.style.display = 'none';
                  accountHolderLabel.style.display = 'none';
                  paymentAccountLabel.style.display = 'none';
              } else {
                  accountHolderField.style.display = 'block';
                  paymentAccountField.style.display = 'block';
                  accountHolderLabel.style.display = 'block';
                  paymentAccountLabel.style.display = 'block';
              }
          }
      } else {
          if (accountHolderField && paymentAccountField && accountHolderLabel && paymentAccountLabel) {
              accountHolderField.style.display = 'none';
              paymentAccountField.style.display = 'none';
              accountHolderLabel.style.display = 'none';
              paymentAccountLabel.style.display = 'none';
          }
      }
  }

  paymentMethodRadios.forEach(radio => {
      radio.addEventListener('change', togglePaymentFields);
  });

  togglePaymentFields();
});
