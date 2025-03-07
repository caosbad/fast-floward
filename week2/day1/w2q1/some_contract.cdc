access(all) contract SomeContract {
    pub var testStruct: SomeStruct

    pub struct SomeStruct {
        // 4 Variables
        //
        pub(set) var a: String

        pub var b: String

        access(contract) var c: String

        access(self) var d: String

        // 3 Functions
        //
        pub fun publicFunc() {}

        access(self) fun privateFunc() {}

        access(contract) fun contractFunc() {}


        pub fun structFunc() {
            // Area 1
            // Variables that can be read: a b c d e.
            // Variables that can be modified: a b c d e.
            // Functions that can be accessed: publicFunc and privateFunc contractFunc:
        }

        init() {
            self.a = "a"
            self.b = "b"
            self.c = "c"
            self.d = "d"
        }
    }

    pub resource SomeResource {
        pub var e: Int

        pub fun resourceFunc() {
            // Area 2
            // Variables that can be read: a b c e.
            // Variables that can be modified: a e.
            // Functions that can be accessed: publicFunc and contractFunc: 
        }

        init() {
            self.e = 17
        }
    }

    pub fun createSomeResource(): @SomeResource {
        return <- create SomeResource()
    }

    pub fun questsAreFun() {
        // Area 3
        // Variables that can be read: a b c e.
        // Variables that can be modified: a .
        // Functions that can be accessed: publicFunc and contractFunc resourceFunc: 
    }

    init() {
        self.testStruct = SomeStruct()
    }
}
