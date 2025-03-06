document.addEventListener("DOMContentLoaded", function () {
  var billingCompanyField = document.getElementById("order_bill_address_attributes_company");
  var shippingCompanyField = document.getElementById("order_ship_address_attributes_company");
  var poNumberFieldBilling = document.getElementById("order_bill_address_attributes_customer_metadata");
  var poNumberFieldShipping = document.getElementById("order_ship_address_attributes_customer_metadata");

  function togglePoNumberField(companyField, poNumberField) {
    if (companyField.value.trim() !== "" && poNumberField) {
      poNumberField.closest('.text-input').style.display = "block";
    } else if (poNumberField) {
      poNumberField.closest('.text-input').style.display = "none";
    }
  }

  // Initial check in case the company name is already filled
  if (billingCompanyField) togglePoNumberField(billingCompanyField, poNumberFieldBilling);
  if (shippingCompanyField) togglePoNumberField(shippingCompanyField, poNumberFieldShipping);

  // Add event listeners to toggle the PO number field on input change
  if (billingCompanyField) {
    billingCompanyField.addEventListener("input", function () {
      togglePoNumberField(billingCompanyField, poNumberFieldBilling);
    });
  }

  if (shippingCompanyField) {
    shippingCompanyField.addEventListener("input", function () {
      togglePoNumberField(shippingCompanyField, poNumberFieldShipping);
    });
  }
});
