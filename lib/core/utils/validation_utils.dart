class ValidationUtils {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidDisplayName(String displayName) {
    return displayName.trim().length >= 2 && displayName.trim().length <= 50;
  }

  static bool isValidStoryTitle(String title) {
    return title.trim().length >= 1 && title.trim().length <= 100;
  }

  static bool isValidStoryContent(String content) {
    return content.trim().length >= 10 && content.trim().length <= 5000;
  }

  static bool isValidImageFile(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  static bool isValidAudioFile(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    return ['mp3', 'm4a', 'wav', 'aac'].contains(extension);
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return '请输入邮箱地址';
    }
    if (!isValidEmail(email)) {
      return '请输入有效的邮箱地址';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return '请输入密码';
    }
    if (!isValidPassword(password)) {
      return '密码长度至少为6位';
    }
    return null;
  }

  static String? validateDisplayName(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return '请输入昵称';
    }
    if (!isValidDisplayName(displayName)) {
      return '昵称长度应在2-50个字符之间';
    }
    return null;
  }

  static String? validateStoryTitle(String? title) {
    if (title == null || title.isEmpty) {
      return '请输入故事标题';
    }
    if (!isValidStoryTitle(title)) {
      return '标题长度应在1-100个字符之间';
    }
    return null;
  }

  static String? validateStoryContent(String? content) {
    if (content == null || content.isEmpty) {
      return '请输入故事内容';
    }
    if (!isValidStoryContent(content)) {
      return '内容长度应在10-5000个字符之间';
    }
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return '请确认密码';
    }
    if (password != confirmPassword) {
      return '两次输入的密码不一致';
    }
    return null;
  }
}
