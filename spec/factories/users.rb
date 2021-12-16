FactoryBot.define do
    factory :user do
        name {"Joe"}
        sequence(:email) {|i| "user#{i}@gmail.com"}
        # email {Faker::Internet.email}
        password {"blahblah"}
        password_confirmation {"blahblah"}
        activated {true}
        admin {false}
    end

    factory :unactivated_user, parent: :user do
        name {"Hloe"}
        sequence(:email) {|i| "unactivate_user#{i}@gmail.com"}
        # email {Faker::Internet.email}
        password {"blahblah"}
        password_confirmation {"blahblah"}
        activated {false}
        admin {false}
    end
end