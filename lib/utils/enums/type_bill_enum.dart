enum TypeBill {
  food,
  shopping,
  entertainment,
  homeBill,
  other,
}

extension TypeBillX on TypeBill {
  int toDBCode() {
    switch(this) {
      case TypeBill.food:
        return 1;
      case TypeBill.shopping:
        return 2;
      case TypeBill.entertainment:
        return 3;
      case TypeBill.homeBill:
        return 4;
      case TypeBill.other:
      default:
        return 0;
    }
  }

  String toStringValue() {
    switch(this) {
      case TypeBill.food:
        return 'Ăn uống';
      case TypeBill.shopping:
        return 'Mua sắm';
      case TypeBill.entertainment:
        return 'Đi chill';
      case TypeBill.homeBill:
        return 'Hóa đơn gia đình';
      case TypeBill.other:
      default:
        return 'Khác';
    }
  }

  static TypeBill fromDBCode(int typeBillCode) {
    switch(typeBillCode) {
      case 1:
        return TypeBill.food;
      case 2:
        return TypeBill.shopping;
      case 3:
        return TypeBill.entertainment;
      case 4:
        return TypeBill.homeBill;
      case 0:
      default:
        return TypeBill.other;
    }
  }
}