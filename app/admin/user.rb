ActiveAdmin.register User do
  index do                            
    column :email                     
    column :current_sign_in_at        
    column :last_sign_in_at           
    column :sign_in_count             
    default_actions                   
  end                                 

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :balance
      f.input :name
      f.input :username
      f.input :number_of_ratings
    end
    f.buttons
  end
end