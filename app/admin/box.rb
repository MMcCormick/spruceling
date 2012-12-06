ActiveAdmin.register Box do
  index do
    column :id
    column :user do |b|
      link_to b.user.name, admin_user_path(b.user)
    end
    column :gender
    column :size
    column :status
    column :price_total
    column :rating
    column :is_featured
  end
end
