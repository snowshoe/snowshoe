#include "CrashGraphicsItem.h"

#include <QtGui/QPainter>

CrashGraphicsItem::CrashGraphicsItem(QGraphicsItem* parent)
    : QGraphicsItem(parent)
{ }

CrashGraphicsItem::~CrashGraphicsItem()
{ }

void CrashGraphicsItem::setGeometry(const QRectF& rect)
{
    m_geometry = rect;
}

QRectF CrashGraphicsItem::boundingRect() const
{
    return m_geometry;
}

void CrashGraphicsItem::paint(QPainter* painter, const QStyleOptionGraphicsItem*, QWidget*)
{
    painter->drawText(m_geometry, Qt::AlignCenter, QLatin1String("The web process has crashed. You can try reloading the page."));
}
