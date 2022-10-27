class QuotationsController < ApplicationController
  def index
    begin
      @document_amount = Integer(params['Monto_de_la_factura'])
      @debtor_dni = params['Rut_Deudor'].sub("-", "")
      @expiration_date = Date.strptime(params['Fecha_de_vencimiento_de_la_factura'], "%Y-%m-%d")
      @date_today = Date.today
      @expiration_days = @expiration_date.mjd - @date_today.mjd + 1
      @response = SimpleQuote.new(
        client_dni: params['Rut_Emisor'],
        debtor_dni: @debtor_dni,
        document_amount: params['Monto_de_la_factura'],
        folio: params['Folio'],
        expiration_date: params['Fecha_de_vencimiento_de_la_factura']
      ).send
      if params.key?("test") && params['test']
        @document_rate = 1.9
        @commission = 23990.0
        @advance_percent = 99.0
      else
        @document_rate = @response.body['document_rate']
        @commission = @response.body['commission']
        @advance_percent = @response.body['advance_percent']
      end

      @Costo_de_financiamiento = (@document_amount * (@advance_percent/100)) * ((@document_rate/100) / 30 * @expiration_days)
      @Giro_a_recibir = (@document_amount * (@advance_percent/100)) - (@Costo_de_financiamiento + @commission)
      @Excedentes = @document_amount - (@document_amount * (@advance_percent/100))
      render json: {
        reponse_service:@response.body,
        Costo_de_financiamiento: ActionController::Base.helpers.number_to_currency(@Costo_de_financiamiento, precision: 0),
        Giro_a_recibir: ActionController::Base.helpers.number_to_currency(@Giro_a_recibir, precision: 0),
        Excedentes: ActionController::Base.helpers.number_to_currency(@Excedentes, precision: 0),
      }
    rescue
      render json: {
        message: 'Failed'
      }
    end
  end
end
