import React from 'react'
import {
  Form as BsForm, FormGroup, FormControl, ControlLabel, Button
} from 'react-bootstrap'
import PropTypes from 'prop-types'
import CurrencySelector from './currency-selector'
import { identity } from 'utilities'

const changeHandler = (actionCreator, attribute, converter = identity) =>
  ({ target: { value } }) => actionCreator({ [attribute]: converter(value) })

const submitHandler = (actionCreator, payload) =>
  (event) => {
    actionCreator(payload)
    event.preventDefault()
  }

const floatConverter = (value) =>
  value.length > 0 ? parseFloat(value) : null

const Form = ({
  onSubmit, onChange, amount, currency, baseRedeemURL, currencies
}) => (
  <BsForm>
    <FormGroup bsSize="large">
      <ControlLabel>Amount</ControlLabel>
      <FormControl
        type="number"
        value={amount !== null ? amount : ''}
        onChange={changeHandler(onChange, 'amount', floatConverter)}
      />
    </FormGroup>
    <FormGroup>
      <ControlLabel>Currency</ControlLabel>
      <CurrencySelector
        onChange={changeHandler(onChange, 'currency')}
        currency={currency}
        currencies={currencies}
      />
    </FormGroup>
    <FormGroup>
      <ControlLabel>Redeem base URL</ControlLabel>
      <FormControl
        type="string"
        value={baseRedeemURL}
        onChange={changeHandler(onChange, 'baseRedeemURL')}
      />
    </FormGroup>
    <FormGroup>
      <Button
        type="submit"
        onClick={submitHandler(onSubmit, { amount, currency })}
      >
        Create
      </Button>
    </FormGroup>
  </BsForm>
)

Form.propTypes = {
  onSubmit: PropTypes.func.isRequired,
  onChange: PropTypes.func.isRequired,
  currency: PropTypes.string.isRequired,
  amount: PropTypes.number,
  baseRedeemURL: PropTypes.string.isRequired,
  currencies: PropTypes.array.isRequired
}

export default Form
