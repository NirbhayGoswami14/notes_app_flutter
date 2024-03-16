class NotesModel
{
  String? id;
  String? title;
  String? note;
  String? time;
  int? isPPC;

  NotesModel(this.id, this.title, this.note, this.time,this.isPPC);

  int get b{
    return isPPC!;
  }
}