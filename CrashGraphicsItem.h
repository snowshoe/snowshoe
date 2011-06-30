#ifndef CrashGraphicsItem_h
#define CrashGraphicsItem_h

#include <QtGui/QGraphicsItem>

class CrashGraphicsItem : public QGraphicsItem
{
public:
    CrashGraphicsItem(QGraphicsItem* parent = 0);
    virtual ~CrashGraphicsItem();

    void setGeometry(const QRectF& rect);
    virtual QRectF boundingRect() const;

    virtual void paint(QPainter*, const QStyleOptionGraphicsItem*, QWidget* = 0);
private:
    QRectF m_geometry;
};

#endif
