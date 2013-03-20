module UsersHelper
  def show_user_roles_options(form)
    options = User.valid_roles.map { |r| [t("view.users.roles.#{r}"), r] }

    form.input :role, collection: options, as: :radio_buttons, label: false,
      input_html: { class: nil }
  end

  def show_user_relation_options(form)
    relations = Relation::TYPE.map { |t| [show_human_relation_type(t), t] }

    form.input :relation, label: false, collection: relations, prompt: true,
      input_html: { class: 'span10' }
  end

  def show_human_relation_type(relation)
    t "view.relation.types.#{relation}"
  end
end
