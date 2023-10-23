class Person{
  final int id;

  final String avatar;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String domain;
  final bool available;

  Person({required this.id, required this.avatar, required this.firstName,required this.lastName,required this.email,
    required this.gender,required this.domain,required this.available});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      avatar: json['avatar'] as String,
      domain: json['domain'] as String,
      available: json['available'],


    );
  }
  static List<Person> filterList(List<Person> person,String string )
  {
    List<Person> _persons = person.where((element) => (element.firstName.toLowerCase().contains(string.toLowerCase()))||
        (element.lastName.toLowerCase().contains(string.toLowerCase()))||
        (element.email.toLowerCase().contains(string.toLowerCase()))).toList();
        return _persons;
  }
}