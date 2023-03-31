import 'package:flutter/material.dart';
import 'package:spending_app/utils/enums/type_bill_enum.dart';

class AppColors {
  static const textFieldBackgroundColor = Color(0x70FFFAFA);
  static const whiteColor = Colors.white;
  static const hintTextColor = Color(0x80000000);
  static const blackColor = Colors.black;
  static const subTitleColor = Color(0xFF757171);

  static const greenStartLinearColor = Color(0xFF29FF06);
  static const greenEndLinearColor = Color(0xFF77FCB4);

  static const redStartLinearColor = Color(0xFFFF0000);
  static const redEndLinearColor = Color(0xFFFF7B7B);
  
  static const navBarStartColor = Color(0xFFACE1FF);
  static const navBarEndColor = Color(0xFFF2ACB0);

  static const purpleStartLinearColor = Color(0xFFC69DFF);
  static const purpleEndLinearColor = Color(0xFF4F76FF);
  static const greenColor = Color.fromARGB(255, 28, 151, 32);
}

class ConstantStrings {
  static final appString = AppString();
  static final dbString = DBString();
}

class AppString {
  final appName = "Monee";

  final email = "Email";
  final password = "Mật khẩu";
  final signIn = "Đăng nhập";
  final notHaveAccount = "Chưa có tài khoản?";
  final signUpNow = "Đăng ký ngay";
  final signUp = "Đăng ký";
  final lastName = "Họ và tên đệm";
  final firstName = "Tên";
  final confirmPassword = "Xác nhận mật khẩu";
  final oldPassword = "Mật khẩu cũ";
  final newPassword = "Mật khẩu mới";
  final confirmNewPassword = "Xác nhận mật khẩu mới";

  final inputLastName = "Nhập họ và tên đệm của bạn";
  final inputFirstName = "Nhập tên của bạn";
  final inputYourEmail = "Nhập email của bạn";
  final inputYourPassword = "Nhập mật khẩu của bạn";
  final inputConfirmPassword = "Xác nhận lại mật khẩu của bạn";
  final inputOldPassword = "Nhập mật khẩu cũ";
  final inputNewPassword = "Nhập mật khẩu mới";
  final inputConfirmNewPassword = "Xác nhận lại mật khẩu mới";

  final warningFillFullText = "Bạn cần điền đầy đủ thông tin";
  final warningTheSamePassword = "Bạn cần nhập mật khẩu giống nhau";

  final errorOccur = "Đã xảy ra lỗi";
  final signInSuccessfully = "Đăng nhập thành công";
  final signUpSuccessfully = "Đăng ký thành công";
  final signOutSuccessfully = "Đăng xuất thành công";

  final verifyEmail = "Xác nhận email";
  final contentVerify = "Chúng tôi đã gửi cho bạn một email xác nhận. Hãy xác nhận email của bạn để tiếp tục sử dụng. Nếu bạn vẫn chưa nhận được email, vui lòng chờ ít phút. Sau khi xác nhận email, vui lòng đăng nhập lại.";
  final userOrPasswordNotCorrect = "Tài khoản hoặc mật khẩu không chính xác";

  final weakPassword = "Mật khẩu cần tối thiểu 6 kí tự";
  final emailAlreadyInUse = "Email đã được sử dụng";
  final invalidEmail = "Email không hợp lệ";

  final homePage = "Trang chủ";
  final group = "Nhóm";
  final personal = "Cá nhân";

  final spentMoneyInMonth = "Số tiền đã tiêu trong tháng";

  final typeStatistic = "Thống kê theo loại";
  final groupStatistic = "Thống kê theo nhóm";

  final joinWithCode = "Tham gia nhóm bằng mã";

  final joinedGroup = "Các nhóm đã tham gia";
  final waitingGroup = "Các nhóm đang chờ phê duyệt";

  final manageGroup = "Quản lý các nhóm của bạn";
  final editYourProfile = "Chỉnh sửa thông tin cá nhân của bạn";

  final createNewGroup = "Tạo nhóm mới";
  final createNewGroupSuccessfully = "Tạo nhóm mới thành công";
  final warningPickGroupImage = "Vui lòng chọn ảnh đại diện của nhóm";

  final addGroupAvatar = "Thêm ảnh đại diện nhóm";
  final groupName = "Tên nhóm";
  final inputGroupName = "Nhập tên nhóm";

  final inputCode = "Nhập mã";
  final inputGroupCode = "Nhập mã nhóm";

  final confirm = "Xác nhận";
  final cancel = "Hủy";

  final selectMember = "Chọn thành viên";
  final member = "Thành viên";
  final expenses = "Các khoản chi";
  final statistic = "Thống kê";

  final editGroupInfo = "Chỉnh sửa thông tin nhóm";
  final manageMember = "Quản lý thành viên";
  final requestsList = "Danh sách chờ";
  final deleteGroup = "Xóa nhóm";
  final confirmDeleteGroup = "Mọi thông tin liên quan đến nhóm này đều sẽ bị xóa. Bạn có chắc chắn muốn xóa nhóm?";
  final outGroup = "Rời khỏi nhóm";
  final confirmOutGroup = "Bạn có chắc chắn muốn rời khỏi nhóm?";
  final outGroupSuccess = "Rời khỏi nhóm thành công";
  final copyGroupCode = "Sao chép mã nhóm";
  final copyGroupCodeSuccess = "Sao chép mã nhóm thành công";


  final cancelRequest = "Hủy yêu cầu";
  final cancelRequestSuccess = "Hủy yêu cầu thành công";

  final acceptAll = "Phê duyệt toàn bộ";
  final deleteAll = "Xóa toàn bộ";

  final confirmAcceptAll = "Bạn có chắc chắn muốn phê duyệt toàn bộ?";
  final confirmDeleteAll = "Bạn có chắc chắn muốn xóa toàn bộ?";

  final accept = "Phê duyệt";
  final confirmAccept = "Bạn có chắc chắn muốn phê duyệt?";
  final delete = "Xóa";
  final confirmDelete = "Bạn có chắc chắn muốn xóa?";
  final acceptSuccess = "Phê duyệt thành công";
  final deleteSuccess = "Xóa thành công";
  final addNewOwnerSuccess = "Thêm chủ nhóm mới thành công";

  final requestSuccess = "Yêu cầu tham gia thành công. Vui lòng chờ chủ nhóm phê duyệt";

  final outOwnerGroup = "Bỏ làm chủ nhóm";
  final removeFromGroup = "Xóa khỏi nhóm";
  final setOwnerGroup = "Đặt làm chủ nhóm";

  final confirmRemoveFromGroup = "Bạn có chắc chắn muốn xóa thành viên này khỏi nhóm?";
  final confirmSetOwnerGroup = "Bạn có chắc chắn muốn đặt người này làm chủ nhóm?";
  final confirmOutOwnerGroup = "Bạn có chắc chắn muốn bỏ làm chủ nhóm?";

  final noRequest = "Không có yêu cầu nào";

  final youAreOnlyOwnerGroup = "Bạn là chủ nhóm duy nhất nên không thể rời nhóm. Cần trao lại quyền chủ nhóm cho người khác";

  final editGroupInfoSuccess = "Chỉnh sửa thông tin thành công";
  final notChangedInfoYet = "Bạn chưa thay đổi thông tin";
  final needAcceptReadRule = "Bạn cần cấp quyền truy cập vào bộ nhớ để chọn ảnh";

  final editInfo = "Chỉnh sửa thông tin";
  final changePassword = "Đổi mật khẩu";

  final selectAvatar = "Chọn ảnh đại diện";

  final wantToExit = "Bạn muốn thoát?";
  final wantToExitContent = "Mọi thay đổi sẽ không được lưu lại. Bạn có chắc chắn muốn thoát?";

  final signOut = "Đăng xuất";
  final confirmSignOut = "Bạn có chắc chắn muốn đăng xuất?";

  final createNewExpense = "Thêm chi tiêu mới";

  final expenseName = "Tên chi tiêu";
  final inputExpenseName = "Nhập tên chi tiêu";
  final type = "Loại";
  final price = "Số tiền";
  final inputPrice = "Nhập số tiền";
  final expenseDate = "Ngày chi";
  final inputExpenseDate = "Chọn ngày chi";

  final mustSelectType = "Bạn cần chọn loại chi tiêu";
  final mustSelectMember = "Bạn cần chọn thành viên";

  final createExpenseSuccess = "Thêm chi tiêu mới thành công";
  final editExpenseSuccess = "Chỉnh sửa chi tiêu thành công";

  final expenseDetail = "Thông tin chi tiết";
  final editExpense = "Chỉnh sửa chi tiêu";
  final deleteExpense = "Xóa chi tiêu";
  final confirmDeleteExpense = "Bạn có chắc chắn muốn xóa chi tiêu này?";

  final expenseOwner = "Người chi";
  final expenseUser = "Người sử dụng";

  final totalMoney = "Tổng số tiền:";
  final notHaveData = "Không có dữ liệu";
  final wrongPassword = "Mật khẩu không chính xác";
  final changePasswordSuccess = "Đổi mật khẩu thành công";
}

class DBString {
  final usersCollection = 'users';
  final groupsCollection = 'groups';
  final expenseGroupsCollection = 'expense_groups';

  final requestsIdList = "requestsIdList";
  final membersIdList = "membersIdList";
  final ownersIdList = "ownersIdList";
  final hashPassword = "hashPassword";

  final groupsIdList = "groupsIdList";
  final requestGroupsIdList = "requestGroupsIdList";
  final imageURL = "imageURL";
  final name = "name";
  final firstName = "firstName";
  final lastName = "lastName";
  final date = "date";
}

class AssetPaths {
  static final imagePath = ImagePath();
  static final iconPath = IconPath();
}

class IconPath {
  final getAlertIconPath = "assets/icons/alert_triangle.svg";
  final getCheckIconPath = "assets/icons/checked_icon.svg";
  final getInfoIconPath = "assets/icons/info_icon.svg";
  final getWarningIconPath = "assets/icons/warning_icon.svg";
  final getKebabMenuIconPath = "assets/icons/kebab_menu.png";
  final getCrownIconPath = "assets/icons/crown.png";
  final getGroupIconPath = "assets/icons/group.png";
  final getWaitingIconPath = "assets/icons/waiting.png";
  final getDeleteIconPath = "assets/icons/delete.png";
  final getLoadingIconPath = "assets/icons/loading.png";
  final getDenyIconPath = "assets/icons/deny.png";
}

class ImagePath {
  final getBackgroundImagePath = "assets/images/bg.png";
  final getLogoImagePath = "assets/images/logo.png";
  final getCardImagePath = "assets/images/card.png";
  final getDefaultLoadingImagePath = "assets/images/default-loading-image.png";
  final getDefaultUserImagePath = "assets/images/default_user.jpg";
}

class ConstantDateTime {
  static final months = List.generate(12, (index) => index + 1);
  static List<int> years = List<int>.generate(70, (index) => DateTime.now().year - index);
}