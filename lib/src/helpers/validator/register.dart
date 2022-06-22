import 'dart:async';

mixin Register{
  var nullValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (accept,sink){
        if(accept != null ){
          sink.add(accept);
        }else{
          sink.addError("This field cannot be empty");
        }
      }
  );

  var nameValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (accept,sink){
        if(accept.length > 2 ){
          sink.add(accept);
        }else{
          sink.addError("This field cannot be empty");
        }
      }
  );
  var acceptValidator = StreamTransformer<bool,bool>.fromHandlers(
      handleData: (accept,sink){
        if(accept){
          sink.add(accept);
        }else{
          sink.addError("Terms and Condition  must be checked");
        }
      }
  );
  var emailValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (email,sink){
      if(email.contains("@")){
        sink.add(email);
      }else{
        sink.addError("Email is not valid");
      }
    }
  );

  var passwordValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){
      if(password.length>4){
        sink.add(password);
      }else{
        sink.addError("Password length should be greater than 4 chars.");
      }
    }
  );
  var noneValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){
      sink.add(password);
    }
  );

}