import React from 'react'
import styled from 'styled-components'
import { Common, Typography, Border, Layout, Flex, CommonProps, TypographyProps, BorderProps, LayoutProps, FlexProps } from 'theme/constants'

export type InputProps = CommonProps & TypographyProps & BorderProps & LayoutProps & FlexProps

export const Input = styled.input<InputProps>`
  box-sizing: border-box;
  outline: none;
  ${Typography};
  ${Common};
  ${Border};
  ${Layout};
  ${Flex};
`
Input.defaultProps = {
  fontFamily: 'body',
  borderWidth: '1px',
  borderStyle: 'solid',
  borderColor: 'blacks.2',
  boxShadow: 'none',
  px: [2],
  py: [1],
}

export const TextInput: React.FC<typeof Input> = (props) => <Input {...props} type="text" />
export const Checkbox: React.FC<typeof Input> = (props) => <Input  {...props} type="checkbox" />
export const Radio: React.FC<typeof Input> = (props) => <Input  {...props} type="radio" />

export default Input
