import styled from 'styled-components'
import { Common, Layout, Flex, Position, Border, CommonProps, LayoutProps, FlexProps, PositionProps, BorderProps } from 'theme/constants'

export type FieldsetProps = CommonProps & LayoutProps & FlexProps & PositionProps & BorderProps

export const Fieldset = styled.fieldset<FieldsetProps>`
  ${Common};
  ${Layout};
  ${Flex};
  ${Position};
  ${Border};
`

Fieldset.defaultProps = {
  border: 'none',
}

export default Fieldset
