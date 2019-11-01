FactoryBot.define do
  factory :message do
    content {Faker::Lorem.sentence}
    image {File.open("#{Rails.root}/public/images/test_image.jpg")}  # 画像データについてはFakerで生成しない、実際の画像データ（test_image.jpg）を用意して参照できるようにする。
    user
    group
  end
end