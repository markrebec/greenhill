import styled from 'styled-components'
import { Common, Layout, Flex, Position, CommonProps, LayoutProps, FlexProps, PositionProps } from 'theme/constants'

export type FormProps = CommonProps & LayoutProps & FlexProps & PositionProps

export const Form = styled.form<FormProps>`
  ${Common};
  ${Layout};
  ${Flex};
  ${Position};
`

export default Form
