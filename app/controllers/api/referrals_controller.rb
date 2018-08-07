module Api
  class ReferralsController < ActionController::Base
    # include UsersHelper
    # before_action :authenticate_user_from_token, except: [:give_appointment_details_for_notification,  :set_password]

    def create_referral
      patient = Patient.find(params[:patient_id])
      referral = Referral.new

      referral.source = params[:source]
      referral.referral_name = params[:referral_name]
      referral.referral_description = params[:referral_description]
      referral.urgency = params[:urgency]
      referral.due_date = params[:due_date]
      referral.patient_id = patient
      referral.save
      if params[:task].blank?
        if referral.save
          render :json=> {status: :ok, message: "Referral Created"}
        else
          render :json=> {status: :ok, message: "Referral not Created"}
        end
      elsif !params[:task].blank?
        logger.debug("Create task********************")
        task = Task.new
        task.task_type = params[:task][:task_type]
        task.task_status = params[:task][:task_status]
        task.task_owner = params[:task][:task_owner]
        task.provider = params[:task][:provider]
        task.task_deadline = params[:task][:task_deadline]
        task.task_description = params[:task][:task_description]
        task.referral_id = referral.id.to_s
        if task.save
          render :json=> {status: :ok, message: "Referral and Task Created"}
        else
          render :json=> {status: :ok, message: "Referral and Task not Created"}
        end
      end
    end

  end
end
