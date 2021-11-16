import React from 'react'
import styled from 'styled-components'
import { Common, Typography, Border, Layout, Flex, CommonProps, TypographyProps, BorderProps, LayoutProps, FlexProps } from 'theme/constants'

export type InputProps = CommonProps & TypographyProps & BorderProps & LayoutProps & FlexProps

export const Input = styled.input<InputProps>`
  box-sizing: border-box;
  outline: none;
  border: 1px solid ${props => props.theme.colors.dark};
  &:focus {
    box-shadow: 0px 0px 5px ${props => props.theme.colors.dark};
  }
  ${Typography};
  ${Common};
  ${Border};
  ${Layout};
  ${Flex};
`
Input.defaultProps = {
  fontFamily: 'body',
  px: [2],
  py: [1],
}

export const TextInput: React.FC<typeof Input> = (props) => <Input {...props} type="text" />
export const Checkbox: React.FC<typeof Input> = (props) => <Input  {...props} type="checkbox" />
export const Radio: React.FC<typeof Input> = (props) => <Input  {...props} type="radio" />

export default Input
