A Notes App
===========
This is a personal project with the primary purpose to play around different technologies, and pratices on iOS development. The overall architecture of this app is soft-compliant to the **VIPER architecture**, I have modified some part of the common implementation such as instead of using plain classes for the components, I took advantage of the `Operations` and `Observers`. One of the goals for this project is to implement its full business logic using `Operations` while keeping in mind that **Swift is a protocol-oriented language** rather than an object-oriented.

**Test-Driven Development**

I implemented this app with this mantra on my mind. I used **Quick** as the BDD(*Behavior-Driven Development*) framework, and `Nimble` for the matcher. 

**Linting**

To follow a specific style guide, I used the linter **SwiftLint** while disabling some rules due to personal preference.

**Realm**

To speed up the development, I tried this service instead of the dichotomous traditional CoreData and back-end web service. So far, it has catered all the requirements I needed for the database and remote integration.

**Documentation**

For the documentation, I used **Jazzy** to provide a easy-build neat interface. Here is the [full documentation](http://www.maryalexissolis.com/cant-remember-it-all/docs) for this project.
