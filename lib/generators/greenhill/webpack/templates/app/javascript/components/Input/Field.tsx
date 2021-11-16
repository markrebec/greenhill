import React, { InputHTMLAttributes } from 'react'
import Box from '../Box'
import Text from '../Text'
import Input from './Input'
import Label from './Label'
import { Fieldset } from '../Form'

export type InputType = typeof Input
export type FieldProps = InputHTMLAttributes<HTMLInputElement> & {
  label?: string
}
export const Field: React.FC<FieldProps> = ({ label, ...props }) => <Fieldset mb={[2, 4]}>
  <Label>
    <Box display="flex" flexDirection="column">
      { label && <Text>{label}</Text>}
      <Input {...(props)} />
    </Box>
  </Label>
</Fieldset>

export default Field