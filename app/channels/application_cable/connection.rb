# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_employee

    def connect
      self.current_employee = find_verified_employee
    end

    private

    def find_verified_employee
      if employee_signed_in?
        current_employee
      else
        reject_unauthorized_connection
      end
    end
  end
end
