class Validations{
  validateName(String value){
    if (value.trim().isEmpty) {
      return "This field can't be empty";
    }
    return null;
  }

  static  validateBillAmount(String amount){

    int count = 0;
    for(int i = 0; i<amount.length; i++){
      if(amount[i]==".")
        count++;
      if(count == 2)
        return "Enter a valid amount";
    }
    try{
      double amt = double.parse(amount);
      if(amt == 0){
        return "Enter a valid amount";
      }
    }catch(e){
      return "Unable to read amount";
    }
    return null;
  }

static  validateAmount(String amount){
    if(amount.trim().isEmpty)
      return "This field can't be empty";
    int count = 0;
    for(int i = 0; i<amount.length; i++){
      if(amount[i]==".")
        count++;
      if(count == 2)
        return "Enter a valid amount";
    }
    try{
      double amt = double.parse(amount);
      if(amt == 0){
        return "Enter a valid amount";
      }
    }catch(e){
      return "Unable to read amount";
    }
    return null;
  }

 static validateQuantity({int? originalQuantity, int? shopAssistantQuantity } ){

    if(originalQuantity!=null && shopAssistantQuantity!=null){
      if(shopAssistantQuantity==0)
        {
          print(shopAssistantQuantity);
          return "Enter quantity";
        }
      if(shopAssistantQuantity<=originalQuantity+15){
        return null;
      }
    }
    return "Invalid quantity";
 }
  static String? validateRequired(String value,String field){
    if (value.trim().isEmpty) {
      return "$field is required";
    }
    return null;
  }
}