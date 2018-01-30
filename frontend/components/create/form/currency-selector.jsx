import PropTypes from 'prop-types'
import React from 'react'
import { FormControl } from 'react-bootstrap'

const CurrencySelector = ({ onChange, currency, currencies }) => (
  <FormControl
    componentClass="select" value={currency} onChange={onChange}
  >
    {currencies.map(({ identifier, label }, index) => (
      <option key={index} value={identifier}>{label}</option>
    ))}
  </FormControl>
)

CurrencySelector.propTypes = {
  onChange: PropTypes.func.isRequired,
  currency: PropTypes.string.isRequired,
  currencies: PropTypes.arrayOf(
    PropTypes.shape({
      identifier: PropTypes.string.isRequired,
      label: PropTypes.string.isRequired
    })
  ).isRequired
}

export default CurrencySelector
