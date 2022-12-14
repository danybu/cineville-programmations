# frozen_string_literal: true

# screeningcomponent for viewcomponent
class ScreeningComponent < ViewComponent::Base
  def initialize(screening:)
    super
    @screening = screening
  end
end
