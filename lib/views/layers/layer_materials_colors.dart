// id,type,category,short,symonym,color,image_file
// 0,Габбро,plotik,Габбро,Габбро,#84BC2E,Габбро.png
// 1,Галечно-гравийные,rud_plast,Галечно-гр,Галечно-гр,#FCEB08,Галечно-гравийные.png
// 2,Глина,torfa,Глина,Глина,#E69A3F,Глина.png
// 3,Гнейсы,plotik,Гнейсы,Гнейсы,#5FB66D,Гнейсы.png
// 4,Гравий-песчано-гравийные,rud_plast,Гравий-пес,Гравий-пес,#FDF183,Гравий-песчано-гравийные.png
// 5,Гранит,plotik,Гранит,Гранит,#E43024,Гранит.png
// 6,Дресвяно-пеПесчано-дресвяные,rud_plast,Дресвяно-п,Дресвяно-пе,#FADBD9,Дресвяно-пеПесчано-дресвяные.png
// 7,Ил ,torfa,Ил ,Ил ,#878887,Ил .png
// 8,Илисто-глинистые,torfa,Илисто-гли,Илисто-гли,#D8AD2C,Илисто-глинистые.png
// 9,Кристаллический сланец,plotik,Кристаллич,Кристаллич,#C091C1,Кристаллический сланец.png
// 10,ОКВ по габбро,plotik,ОКВ по габ,ОКВ по габ,#D3E7CA,ОКВ по габбро.png
// 11,ОКВ по гнейсам,plotik,ОКВ по гне,ОКВ по гне,#7EC28A,ОКВ по гнейсам.png
// 12,ОКВ по гранитам,plotik,ОКВ по гра,ОКВ по гра,#F7B17A,ОКВ по гранитам.png
// 13,ОКВ по кристаллическим сланцам,plotik,ОКВ по кри,ОКВ по кри,#E3C6E1,ОКВ по кристаллическим сланцам.png
// 14,ОКВ по сланцам,plotik,ОКВ по сла,ОКВ по сла,#6D551A,ОКВ по сланцам.png
// 15,Песок,rud_plast,Песок,Песок,#FDF8C7,Песок.png
// 16,Песчано-илистые,torfa,Песчано-ил,Песчано-ил,#C9CACB,Песчано-илистые.png
// 17,ПКВ,rud_plast,ПКВ,ПКВ,#BBD261,ПКВ.png
// 18,ПРС-Торф,prs,ПРС-Торф,ПРС-Торф,#FEE6B0,ПРС-Торф.png
// 19,ПРС,prs,ПРС,ПРС,#FEE6B0,ПРС.png
// 20,Суглинок,torfa,Суглинок,Cуглинок,#D8AD2C,Суглинок.png
// 21,Супесь-глинисто-песчаные,torfa,Супесь-гли,Супесь-гли,#F6BF12,Супесь-глинисто-песчаные.png
// 22,Щебнисто-галечн,rud_plast,Щебнисто-г,Щебнисто-г,#E6E678,Щебнисто-галечн.png
// 23,Щебнисто-дресвяные,rud_plast,Щебнисто-д,Щебнисто-д,#F29392,Щебнисто-дресвяные.png

import 'dart:ui';

class LayerMaterialColorPicker {
  static Color getMaterialColor(String name) {
    String hexColor = "#FCEB08";
    switch (name) {
      case "Габбро":
        hexColor = "#84bc2e";
        break;
      case "Галечно-гравийные":
        hexColor = "#FCEB08";
        break;
      case "Глина":
        hexColor = "#E69A3F";
        break;
      case "Гнейсы":
        hexColor = "#5FB66D";
        break;
      case "Гравий-песчано-гравийные":
        hexColor = "#FDF183";
        break;
      case "Гранит":
        hexColor = "#E43024";
        break;
      case "Дресвяно-пеПесчано-дресвяные":
        hexColor = "#FADBD9";
        break;
      case "Ил":
        hexColor = "#878887";
        break;
      case "Илисто-глинистые":
        hexColor = "#D8AD2C";
        break;
      case "Кристаллический сланец":
        hexColor = "#C091C1";
        break;
      case "ОКВ по габбро":
        hexColor = "#D3E7CA";
        break;
      case "ОКВ по гнейсам":
        hexColor = "#7EC28A";
        break;
      case "ОКВ по гранитам":
        hexColor = "#F7B17A";
        break;
      case "ОКВ по кристаллическим сланцам":
        hexColor = "#E3C6E1";
        break;
      case "ОКВ по сланцам":
        hexColor = "#6D551A";
        break;
      case "Песок":
        hexColor = "#FDF8C7";
        break;
      case "Песчано-илистые":
        hexColor = "#C9CACB";
        break;
      case "ПКВ":
        hexColor = "#BBD261";
        break;
      case "ПРС-Торф":
        hexColor = "#FEE6B0";
        break;
      case "ПРС":
        hexColor = "#FEE6B0";
        break;
      case "Суглинок":
        hexColor = "#D8AD2C";
        break;
      case "Супесь-глинисто-песчаные":
        hexColor = "#F6BF12";
        break;
      case "Щебнисто-галечн":
        hexColor = "#E6E678";
        break;
      case "Щебнисто-дресвяные":
        hexColor = "#F29392";
        break;
      default:
        hexColor = "#FFFFFF";
    }

    String color = hexColor.replaceAll('#', '0xff');

    return Color(int.parse(color));
  }
}